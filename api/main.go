package main

import (
	"duomly.com/go-bank-backend/api"
	"duomly.com/go-bank-backend/database"
)

func main() {
	database.InitDatabase()
	api.StartApi()
}
