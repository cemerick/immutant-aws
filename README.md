# Immutant on AWS <small>(and Vagrant)</small>

# WIP WIP WIP WIP WIP WIP

Seriously, don't use this (yet?). I'm a hack.

## S3_PING

If at all possible, your application should be running on nodes that have
assigned IAM roles, [so you can avoid shipping credentials everywhere](http://docs.aws.amazon.com/AWSSdkDocsJava/latest/DeveloperGuide/java-dg-roles.html).  Unfortunately, S3_PING doesn't support this method, so you need to provide credentials for it at a minimum.

Given that, do what you can to limit the privileges associated with those
credentials.  This is the tightest IAM user policy you can use with S3_PING
AFAICT:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Sid": "AllowUserFullAccessToS3_PINGBucket",
      "Resource": [
        "arn:aws:s3:::$BUCKET_NAME_HERE",
        "arn:aws:s3:::$BUCKET_NAME_HERE/*"
      ],
      "Effect": "Allow"
    },
    {
      "Sid": "AllowUserToSeeBucketListInTheConsole",
      "Action": ["s3:GetBucketLocation", "s3:ListAllMyBuckets"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::*"]
    }
  ]
}
```

Replace `$BUCKET_NAME_HERE` with the name of the S3 bucket you want JGroups to
use.

## TODOs

* Automate generation/use of pre-signed URLs with S3_PING
* Investigate [jgroups-aws](https://github.com/meltmedia/jgroups-aws) instead of
  S3_PING. It should be:
    * More efficient?
    * More importantly, it's more secure: can use EC2 node IAM roles, which
      would make it possible to eliminate all AWS credentials from residing on
      an immutant AMI

## Credits

* Big /ht to Damion Junk and [his writeup of getting Immutant/Torquebox wired up
  on AWS](http://damionjunk.com/2013/05/20/awsimmutantclustering/). The S3_PING
  configuration in this repo is basically a copy/paste job from that post.
