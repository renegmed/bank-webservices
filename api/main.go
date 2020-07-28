package main

import (
	"duomly.com/go-bank-backend/api"
	// "duomly.com/go-bank-backend/migrations"
)

func main() {
	//migrations.Migrate()
	//migrations.MigrateTransactions()
	api.StartApi()
}
