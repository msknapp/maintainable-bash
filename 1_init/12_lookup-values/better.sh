#!/usr/bin/env bash

get_hosted_zone() {
    local region='us-east-1'
    parse_quick_parameters 'region=-r|--region' $@
    aws route53 --region "${region}" list-hosted-zones \
        --query 'HostedZones[?Config.PrivateZone==`true`].[Id]' --output text | sed -E 's|/.*/||g'
}

function list_resource_record_sets {
    local pattern='prod'; local region='us-east-1'; local zone='';
    parse_quick_parameters 'zone=-z|--zone,pattern=-p|--pattern,region=-r|--region' $@
    # If the zone is not set, then get it:
    [ "$zone" ] || zone=$(get_hosted_zone -r "$region")
    aws route53 list-resource-record-sets --hosted-zone-id "${zone}" --output text \
        --query 'ResourceRecordSets[?contains(Name,`'$pattern'`)].[Name,Type,ResourceRecords[0].Value]'
}

list_resource_record_sets $@