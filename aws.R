


aws.s3::put_object(file = "mapping",object="mapping",bucket="mada-whales")


# Only works locally
saveRDS(mapping,file="data_backup/mapping.Rdata")
put_object(file = "data_backup/mapping.Rdata",
           object = "mapping.Rdata",bucket = s3BucketName)



# To read data:
## s3readRDS(object = "shark_scars.Rdata",bucket = s3BucketName)
