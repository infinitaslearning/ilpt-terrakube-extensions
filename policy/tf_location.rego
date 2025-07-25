package terraform.analysis

import input as tfplan

########################
# Parameters for Policy
########################

allowed_locations := ["westeurope","northeurope"]

#########
# Policy
#########

all_new_resources := [res | res := input.resource_changes[_]; res.change.actions[_] == "create"]

notallowedlocations := [res |
		some res in all_new_resources
		not res.change.after.location in allowed_locations
	]


notallowedlocationsmsg[msg] := value if {
	some res in notallowedlocations
	msg := sprintf("location %s is not allowed on %s",[res.change.after.location ,res.address])
	value := false
}
