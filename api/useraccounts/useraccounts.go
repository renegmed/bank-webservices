package useraccounts

import (
	"fmt"

	"duomly.com/go-bank-backend/transactions"

	"duomly.com/go-bank-backend/interfaces"

	"duomly.com/go-bank-backend/database"
	"duomly.com/go-bank-backend/helpers"
)

func updateAccount(id uint, amount int) interfaces.ResponseAccount {

	account := &interfaces.Account{}
	database.DB.Where("id = ? ", id).First(&account)

	// if db.Where("id = ? ", id).First(&account).RecordNotFound() {
	// 	return nil
	// }
	account.Balance = uint(amount)
	database.DB.Save(&account)

	responseAcc := interfaces.ResponseAccount{}
	responseAcc.ID = account.ID
	responseAcc.Name = account.Name
	responseAcc.Balance = int(account.Balance)

	return responseAcc
}

func getAccount(id uint) *interfaces.Account {
	account := &interfaces.Account{}
	database.DB.Where("id = ? ", id).First(&account)
	// if db.Where("id = ? ", id).First(&account).RecordNotFound() {
	// 	return nil
	// }

	return account
}

func Transaction(userId, from, to uint, amount int, jwt string) map[string]interface{} {
	userIdString := fmt.Sprint(userId)
	isValid := helpers.ValidateToken(userIdString, jwt)

	if isValid {
		fromAccount := getAccount(from)
		toAccount := getAccount(to)
		if fromAccount == nil || toAccount == nil {
			return map[string]interface{}{"message": "Account not found"}
		} else if fromAccount.UserID != userId {
			return map[string]interface{}{"message": "You are not owrner of the account"}
		} else if fromAccount.Balance < uint(amount) {
			return map[string]interface{}{"message": "Account balance is too small"}
		}

		updatedAccount := updateAccount(from, int(fromAccount.Balance)-amount)
		updateAccount(to, int(fromAccount.Balance)+amount)

		transactions.CreateTransaction(from, to, amount)

		var response = map[string]interface{}{"message": "all is fine"}
		response["data"] = updatedAccount
		return response

	} else {
		return map[string]interface{}{"message": "Not valid token"}
	}
}
