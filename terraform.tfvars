resource_group_name = "aks_tf_resgrp"
location            = "EastUS"
cluster_name        = "devops-hml-aks"
kubernetes_version  = "1.19.13"
system_node_count   = 2
acr_name            = "myacr2210"

#define values to the variables in variables.tf file
#you can change the region here to a less costy in location