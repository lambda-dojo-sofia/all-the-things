package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"sort"
	"time"
)

type input struct {
	Records Records `json:"records"`
}

type Records []record

func (rs Records) Len() int      { return len(rs) }
func (rs Records) Swap(i, j int) { rs[i], rs[j] = rs[j], rs[i] }
func (rs Records) Less(i, j int) bool {
	return rs[i].Cases > rs[j].Cases
}

type record struct {
	Date  string `json:"dateRep"`
	Cases int32  `json:"cases,string"`
	ISO3  string `json:"countriesAndTerritories"`
}

func check(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	start := time.Now()

	if len(os.Args) != 3 {
		fmt.Printf("Usage: %s FILE DATE\n", os.Args[0])
		os.Exit(1)
	}

	file, date := os.Args[1], os.Args[2]

	data, err := ioutil.ReadFile(file)
	check(err)
	var parsed input
	startUnmarshal := time.Now()
	err = json.Unmarshal(data, &parsed)
	check(err)

	elapsed("read file and unmarshal", startUnmarshal)

	filtered := make(Records, 0, 0)
	for _, r := range parsed.Records {
		if r.Date == date {
			filtered = append(filtered, r)
		}
	}

	sort.Sort(filtered)

	for i := range filtered[0:5] {
		fmt.Printf("%d\t%s\n", filtered[i].Cases, filtered[i].ISO3)
	}

	elapsed("total", start)
}

func elapsed(msg string, start time.Time) {
	now := time.Now()
	elapsed := now.Sub(start)

	fmt.Printf("%s elapsed: %d miliseconds\n", msg, elapsed.Milliseconds())
}
