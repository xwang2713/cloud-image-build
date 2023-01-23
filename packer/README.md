### Use shared credentials file
https://developer.hashicorp.com/packer/plugins/builders/amazon
In ./.aws/credentials
```code
[profile_name]
aws_access_key_id=<your access key id>
aws_secret_access_key=<your secret access key>
```
In Packer json file
```code
"builders": {
  "type": "amazon-ebs"
  "profile": "profile_name",
  "region": "us-east-1",
}
```

You can skip subnet in this packer json file so packer will pick a one for you

