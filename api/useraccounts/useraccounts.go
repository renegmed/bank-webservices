package useraccounts

import (
	"duomly.com/go-bank-backend/interfaces"

	"duomly.com/go-bank-backend/helpers"
)

func updateAccount(id uint, amount int) {
	db := helpers.ConnectDB()
	db.Model(&interfaces.Account{}).Where("id=?", id).Update("balance", amount))
	defer db.Close()

}
