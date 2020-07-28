package database

import (
	"fmt"
	"log"
	"os"

	"duomly.com/go-bank-backend/helpers"
	"github.com/jinzhu/gorm"
)

var DB *gorm.DB

func InitDatabase() {
	dbName := os.Getenv("DB_NAME")
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbPort := os.Getenv("DB_PORT")
	dbHost := os.Getenv("DB_HOST")

	log.Printf("host=%s, port=%s, user=%s, dbname=%s, password=%s", dbHost, dbPort, dbUser, dbName, dbPassword)

	database, err := gorm.Open(fmt.Sprintf("%s", dbHost),
		fmt.Sprintf("host=%s port=%s user=%s dbname=%s password=%s sslmode=disable", dbHost, dbPort, dbUser, dbName, dbPassword))

	//database, err := gorm.Open("postgres", "host:127.0.0.1 port=5432 user=postgres dbname=bankapp password=postgres sslmode=disable")
	helpers.HandleErr(err)
	database.DB().SetMaxIdleConns(20)
	database.DB().SetMaxOpenConns(200)
	DB = database
}
