package helpers

import (
	"crypto/md5"
	"encoding/hex"
	"regexp"

	"duomly.com/go-bank-backend/interfaces"

	"github.com/jinzhu/gorm"
	// _ "github.com/lib/pq"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"golang.org/x/crypto/bcrypt"
)

func HandleErr(err error) {
	if err != nil {
		panic(err.Error())
	}
}

func HashAndSalt(pass []byte) string {
	hashed, err := bcrypt.GenerateFromPassword(pass, bcrypt.MinCost)
	HandleErr(err)

	return string(hashed)
}

func HashOnlyVulnerable(pass []byte) string {
	hash := md5.New()
	hash.Write(pass)
	return hex.EncodeToString(hash.Sum(nil))
}

func ConnectDB() *gorm.DB {
	db, err := gorm.Open("postgres", "host=postgres port=5432 user=postgres dbname=bankapp password=postgres sslmode=disable")
	HandleErr(err)
	return db
}

func Validation(values []interfaces.Validation) bool {
	username := regexp.MustCompile(`^([A-Za-z0-9]{5,})+$`)
	email := regexp.MustCompile(`^[A-Za-z0-9]+[@]+[A-Za-z0-9]+[.]+[A-Za-z0-9]+$`)
	for i := 0; i < len(values); i++ {
		switch values[i].Valid {
		case "username":
			if !username.MatchString(values[i].Value) {
				return false
			}
		case "email":
			if !email.MatchString(values[i].Value) {
				return false
			}
		case "password":
			if len(values[i].Value) < 5 {
				return false
			}
		}
	}
	return true
}
