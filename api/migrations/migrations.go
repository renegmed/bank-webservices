package migrations

import (
	"duomly.com/go-bank-backend/database"

	"duomly.com/go-bank-backend/helpers"
	"duomly.com/go-bank-backend/interfaces"
	_ "github.com/jinzhu/gorm/dialects/postgres"
)

func createAccounts() {

	users := &[1]interfaces.User{
		{Username: "Michael", Email: "michael@michael.com", Password: "Michael"},
	}

	for i := 0; i < len(users); i++ {

		password := helpers.HashAndSalt([]byte(users[i].Password))
		user := &interfaces.User{Username: users[i].Username, Email: users[i].Email, Password: password}
		database.DB.Create(&user)

		account := &interfaces.Account{Type: "Daily Account", Name: string(users[i].Username + "'s" + " account"), Balance: uint(1000 * int(i+1)), UserID: user.ID}
		database.DB.Create(&account)
	}

}

func Migrate() {
	User := &interfaces.User{}
	Account := &interfaces.Account{}
	database.DB.AutoMigrate(&User, &Account)
	// Use manual sql insert into accounts balance value
	//createAccounts() // for initial startup
}

func MigrateTransactions() {
	Transaction := &interfaces.Transaction{}
	database.DB.AutoMigrate(&Transaction)
}
