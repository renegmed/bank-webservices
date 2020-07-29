package api

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"duomly.com/go-bank-backend/transactions"

	"duomly.com/go-bank-backend/migrations"

	"duomly.com/go-bank-backend/helpers"
	"duomly.com/go-bank-backend/useraccounts"
	"duomly.com/go-bank-backend/users"

	"github.com/gorilla/mux"
)

type Login struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type ErrResponse struct {
	Message string `json:"message"`
}

type Register struct {
	Username string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type TransactionBody struct {
	UserId uint `json:"userid"`
	From   uint `json:"from"`
	To     uint `json:"to"`
	Amount int  `json:"amount"`
}

func readBody(r *http.Request) []byte {
	body, err := ioutil.ReadAll(r.Body)
	helpers.HandleErr(err)
	return body
}

func apiResponse(call map[string]interface{}, w http.ResponseWriter) {
	if call["message"] == "all is fine" {
		resp := call
		json.NewEncoder(w).Encode(resp)
	} else {
		resp := call
		json.NewEncoder(w).Encode(resp)
	}
}
func login(w http.ResponseWriter, r *http.Request) {

	body := readBody(r)

	var formattedBody Login
	err := json.Unmarshal(body, &formattedBody)
	helpers.HandleErr(err)
	login := users.Login(formattedBody.Username, formattedBody.Password)

	apiResponse(login, w)
}

func register(w http.ResponseWriter, r *http.Request) {

	body := readBody(r)

	var formattedBody Register
	err := json.Unmarshal(body, &formattedBody)
	helpers.HandleErr(err)
	register := users.Register(formattedBody.Username, formattedBody.Email, formattedBody.Password)

	fmt.Println("Register:\n\t", register)
	apiResponse(register, w)
}

func getUser(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	userId := vars["id"]
	auth := r.Header.Get("Authorization")

	user := users.GetUser(userId, auth)
	log.Printf("getUser:\n\t %v", user)
	apiResponse(user, w)
}

func transaction(w http.ResponseWriter, r *http.Request) {
	body := readBody(r)
	auth := r.Header.Get("Authorization")

	log.Println("Body: ", string(body))

	log.Println("Auth: ", auth)

	var formattedBody TransactionBody
	err := json.Unmarshal(body, &formattedBody)
	helpers.HandleErr(err)

	transaction := useraccounts.Transaction(formattedBody.UserId, formattedBody.From, formattedBody.To, formattedBody.Amount, auth)

	apiResponse(transaction, w)
}

func migrate(w http.ResponseWriter, r *http.Request) {

	log.Println("Start migrations...")

	migrations.Migrate()
	migrations.MigrateTransactions()

	log.Println("Done migrations...")

	var resp = make(map[string]interface{}) //; map[string]interface{}
	resp["message"] = "all is fine"
	apiResponse(resp, w)
}

func getMyTransactions(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	userId := vars["userID"]
	auth := r.Header.Get("Authorization")
	transactions := transactions.GetMyTransactions(userId, auth)
	apiResponse(transactions, w)
}

func StartApi() {
	router := mux.NewRouter()
	router.Use(helpers.PanicHandler)
	router.HandleFunc("/migrate", migrate).Methods("POST")
	router.HandleFunc("/login", login).Methods("POST")
	router.HandleFunc("/register", register).Methods("POST")
	router.HandleFunc("/transaction", transaction).Methods("POST")
	router.HandleFunc("/transactions/{userID}", getMyTransactions).Methods("GET")
	router.HandleFunc("/user/{id}", getUser).Methods("GET")
	fmt.Println("App is working on port :8888")
	log.Fatal(http.ListenAndServe(":8888", router))
}
