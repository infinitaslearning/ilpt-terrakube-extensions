package terraform.analysis

import input as tfplan

########################
# Parameters for Policy
########################

opco_abbreviations := ["PU","NU","IL","IM","LI","LL","DB"]
team_abbreviations := ["ccc","pe","he","se","da","sims","ecom","integ","pro","oda","lx","umc","ebook"]
dtap_abbreviations := ["dev","acc","tst","stg","prd","shared","nonprd"]
segment_abbreviations := ["itops","pe","he","se","da","sims","ecom","integ","pro","oda","lx","finops","ilpt"]


#########
# Policy
#########

all_resources := [res | res := input.resource_changes[_]; res.change.actions[_] != "delete"]


#first check to see if it is missing all tags
missingAllTags := [res |
		some res in all_resources
		res.change.after.tags == {}
]

#check DTAP tags
notalloweddtap := [res |
		some res in all_resources
		not res.change.after.tags["DTAP"] in dtap_abbreviations
	]

missingdtap := [res |
		some res in all_resources
		not "DTAP" in object.keys(res.change.after.tags) 
]

#checking opco tags
notallowedopco := [res |
		some res in all_resources
		not res.change.after.tags["Opco"] in opco_abbreviations
	]

missingopco := [res |
		some res in all_resources
		not "Opco" in object.keys(res.change.after.tags) 
]

#checking team tags
notallowedteam := [res |
		some res in all_resources
		not res.change.after.tags["Team"] in team_abbreviations
	]

missingteam := [res |
		some res in all_resources
		not "Team" in object.keys(res.change.after.tags) 
]

#checking Segment tags
notallowedsegment := [res |
		some res in all_resources
		not res.change.after.tags["Segment"] in segment_abbreviations
	]

missingsegment := [res |
		some res in all_resources
		not "Segment" in object.keys(res.change.after.tags) 
]

missingrelated := [res |
		some res in all_resources
		not "Related" in object.keys(res.change.after.tags) 
]

missingsourcerepository := [res |
		some res in all_resources
		not "Source_repository" in object.keys(res.change.after.tags) 
]

#NOW check the values and give message back.
checktags[msg] if {
	some res in notalloweddtap
	msg := sprintf("dtap %s is not allowed on %s. valid values are %s.",[res.change.after.tags["DTAP"] ,res.address, dtap_abbreviations])
	value := true
}

checktags[msg] if {
	some res in missingdtap
	msg := sprintf("DTAP tag missing on %s",[res.address])
	value := true
}

checktags[msg] if {
	some res in missingAllTags
	msg := sprintf("All tags missing on %s",[res.address])
	value := true
}

checktags[msg] if {
	some res in notallowedopco
	msg := sprintf("opco %s is not allowed on %s. valid values are %s.",[res.change.after.tags["Opco"] ,res.address, opco_abbreviations])
	value := true
}

checktags[msg] if {
	some res in missingopco
	msg := sprintf("Opco tag missing on %s",[res.address])
	value := true
}

checktags[msg] if {
	some res in notallowedteam
	msg := sprintf("Team %s is not allowed on %s. valid values are %s.",[res.change.after.tags["Team"] ,res.address, team_abbreviations])
	value := true
}

checktags[msg] if {
	some res in missingteam
	msg := sprintf("Team tag missing on %s",[res.address])
	value := true
}

checktags[msg] if {
	some res in notallowedsegment
	msg := sprintf("Segment %s is not allowed on %s. valid values are %s.",[res.change.after.tags["Segment"] ,res.address, segment_abbreviations])
	value := true
}

checktags[msg] if {
	some res in missingsegment
	msg := sprintf("Segment tag missing on %s",[res.address])
	value := true
}

checktags[msg] if {
	some res in missingrelated
	msg := sprintf("Related tag missing on %s",[res.address])
	value := true
}

checktags[msg] if {
	some res in missingsourcerepository
	msg := sprintf("Source_repository tag missing on %s",[res.address])
	value := true
}