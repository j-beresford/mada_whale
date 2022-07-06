s3BucketName <- "mada-whales"

Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIA5XT6TOTDOT7VUQEB",
           "AWS_SECRET_ACCESS_KEY" = "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",
           "AWS_DEFAULT_REGION" = "eu-west-2")


saveRDS(shark_scars,file="data_backup/shark_scars.Rdata")
put_object(file = "data_backup/shark_scars.Rdata",
           object = "shark_scars.Rdata",bucket = s3BucketName)


saveRDS(shark_sightings,file="data_backup/shark_sightings.Rdata")
put_object(file = "data_backup/shark_sightings.Rdata",
           object = "shark_sightings.Rdata",bucket = s3BucketName)

saveRDS(known_sharks,file="data_backup/known_sharks.Rdata")
put_object(file = "data_backup/known_sharks.Rdata",
           object = "known_sharks.Rdata",bucket = s3BucketName)



# To read data:
s3readRDS(object = "shark_scars.Rdata",bucket = s3BucketName)
