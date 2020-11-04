package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
	"github.com/lucasepe/aws-go-tutorial/hello-custom-event/haversine"
)

// Place is a geographic location.
type Place struct {
	ID  string  `json:"id"`
	Lat float64 `json:"lat"`
	Lon float64 `json:"lon"`
}

// QueryDistanceEvent is the Lambda input event.
type QueryDistanceEvent struct {
	From Place `json:"from"`
	To   Place `json:"to"`
}

// The entry point that runs your Lambda function code.
func main() {
	lambda.Start(handler)
}

// handler is your Lambda handler signature and includes the code which will be executed.
//
// See https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html for valid handler signatures.
// See https://github.com/aws/aws-lambda-go for event details.
func handler(ctx context.Context, evt QueryDistanceEvent) {
	lc, _ := lambdacontext.FromContext(ctx)
	fmt.Printf("Aws RequestID: %s\n", lc.AwsRequestID)

	src := haversine.Coord{Lat: evt.From.Lat, Lon: evt.From.Lat}
	dst := haversine.Coord{Lat: evt.To.Lat, Lon: evt.To.Lon}
	mi, km := haversine.Distance(src, dst)

	fmt.Printf("%s is %.3f km (%.3f mi) from %s", evt.From.ID, km, mi, evt.To.ID)
}
