#!/usr/bin/env bash

function list_resource_record_sets {
    local pattern='prod'
    local zone=''
    parse_quick_parameters 'zone=-z|--zone,pattern=-p|--pattern' $@
    aws route53 list-resource-record-sets --hosted-zone-id "${zone}" --output text \
        --query 'ResourceRecordSets[?contains(Name,`'$pattern'`].[Name,Type,ResourceRecords[0].Value]'
}

list_resource_record_sets $@