package helpers

import (
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"log"
	"net/http"
	"regexp"
	"strconv"
	"strings"

	"duomly.com/go-bank-backend/interfaces"
	jwt "github.com/dgrijalva/jwt-go"

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

func Validation(values []interfaces.Validation) bool {
	username := regexp.MustCompile(`^([A-Za-z0-9]{5,})+$`)
	email := regexp.MustCompile(`^[A-Za-z0-9]+[@]+[A-Za-z0-9]+[.]+[A-Za-z0-9]+$`)
	for i := 0; i < len(values); i++ {
		switch values[i].Valid {
		case "username":
			if !username.MatchString(values[i].Value) {
				log.Println("invalid username", values[i].Value)
				return false
			}
		case "email":
			if !email.MatchString(values[i].Value) {
				log.Println("invalid email", values[i].Value)
				return false
			}
		case "password":
			if len(values[i].Value) < 5 {
				log.Println("invalid password", values[i].Value)
				return false
			}
		}
	}
	return true
}

func PanicHandler(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			err := recover()
			if err != nil {
				log.Println(err)
				resp := interfaces.ErrResponse{Message: "Internal server error"}
				json.NewEncoder(w).Encode(resp)
			}
		}()
		next.ServeHTTP(w, r)
	})
}

func ValidateToken(id string, jwtToken string) bool {
	cleanJWT := strings.Replace(jwtToken, "Bearer ", "", -1)
	tokenData := jwt.MapClaims{}
	token, err := jwt.ParseWithClaims(cleanJWT, tokenData, func(token *jwt.Token) (interface{}, error) {
		return []byte("TokenPassword"), nil
	})
	HandleErr(err)
	var userId, _ = strconv.ParseFloat(id, 8)

	log.Printf("ValidateToken() token.Valid: %v, tokenData[user_id]: %v, userId: %v", token.Valid, tokenData["user_id"], userId)

	if token.Valid && tokenData["user_id"] == userId {
		return true
	} else {
		return false
	}
}
