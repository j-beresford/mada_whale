s3BucketName <- "mada-whales"

Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIA5XT6TOTDOT7VUQEB",
           "AWS_SECRET_ACCESS_KEY" = "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",
           "AWS_DEFAULT_REGION" = "eu-west-2")

obj<-get_bucket(bucket = s3BucketName)
## get the object in memory
x <- get_object(obj[[1]])
load(rawConnection(x))

