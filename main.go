package main

import (
	"fmt"
	"io/ioutil"

	"github.com/ethereum/go-ethereum/accounts/keystore"
	"github.com/ethereum/go-ethereum/crypto"
)

func main() {
	inPath := "./node-1/data/keystore/UTC--2024-06-29T11-43-22.708610661Z--33742a719fe3120fdd4ad24b8f288902dfd39583"
	password := "aymaan"
	outPath := "./node-1/data/keystore/extracted-keyfile"

	keyjson, err := ioutil.ReadFile(inPath)
	if err != nil {
		panic(err)
	}

	key, err := keystore.DecryptKey(keyjson, password)
	if err != nil {
		panic(err)
	}

	err = crypto.SaveECDSA(outPath, key.PrivateKey)
	if err != nil {
		panic(err)
	}

	fmt.Println("Key saved to:", outPath)
}
