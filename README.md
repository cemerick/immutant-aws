# Immutant on AWS <small>(and Vagrant)</small>

# WIP WIP WIP WIP WIP WIP

Seriously, don't use this (yet?). I'm a hack.

## S3_PING

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

## TODOs

* Investigate [jgroups-aws](https://github.com/meltmedia/jgroups-aws) instead of
  S3_PING. Presumably it is more efficient? Does it really matter (since S3
  latency [either on requests or replication of new state] is only important
  when cluster changes are afoot)?

## Credits

* Big /ht to Damion Junk and [his writeup of getting Immutant/Torquebox wired up
  on AWS](http://damionjunk.com/2013/05/20/awsimmutantclustering/). The S3_PING
  configuration in this repo is basically a copy/paste job from that post.
