#All drug-gene interactions are query-able via HTTP request, behind a simple URL:
curl http://dgidb.genome.wustl.edu/api/v1/interactions.json

#	{"error":"Please enter at least one gene category to search!"}

#with results in JSON format, 

#One or more genes can be specified by adding a "genes" parameter:
curl http://dgidb.genome.wustl.edu/api/v1/interactions.json?genes=FLT3

#	(big blob of stuff)

#The results can be made more readable on the command-line by piping through a filter to pretty them up:
curl http://dgidb.genome.wustl.edu/api/v1/interactions.json?genes=FLT3 | python -mjson.tool

#	(prettier stuff)

#To query for multiple genes at once, comma-separate the list:
curl http://dgidb.genome.wustl.edu/api/v1/interactions.json?genes=FLT3,STK1,FAKE1 | python -mjson.tool

#	(more pretty stuff)

#The results include matchedTerms and unmatchedTerms.  In the above example, only FLT3 is properly matched.  

#	{
#		matchedTerms => [ … ],
#		unmatchedTerms => [ … ]
#	}

#There is one big hash per search term is returned.  The hash contains the searchTerm, geneName and longGeneName, as well as an array of categories the gene falls into, and an array of drug interactions.

#        {
#          	"searchTerm": "FLT3",
#		"geneName": "FLT3",           
#  		"geneLongName": "fms-related tyrosine kinase 3", 
#          	"geneCategories": [
#                	"TYROSINE KINASE", 
#                	"DRUGGABLE GENOME", 
#                	"KINASE", 
#                	"CELL SURFACE"
#            	], 
#            	"interactions": [ … ]
#    	}

#The list of interactions is a list of hashes, one per case of interaction, including the source:

#                {
#                    "drugName": "SUNITINIB", 
#                    "interactionId": "6a613fef-7365-4ed5-adb7-cca18214377f", 
#                    "interactionType": "inhibitor", 
#                    "source": "MyCancerGenome"
#                }

#Ambiguous matches return suggestions to clarify the ambiguous gene name:
curl http://dgidb.genome.wustl.edu/api/v1/interactions.json?genes=STK1,FAKE1 | python -mjson.tool

# {
#    "matchedTerms": [], 
#    "unmatchedTerms": [
#        {
#            "searchTerm": "STK1", 
#            "suggestions": [
#                "CDK7", 
#                "FLT3"
#            ]
#        }, 
#        {
#            "searchTerm": "FAKE1", 
#            "suggestions": []
#        }
#    ]
#}

#Search terms not recognized are listed as "unmatched", but with no suggestions:
curl http://dgidb.genome.wustl.edu/api/v1/interactions.json?genes=STK1,FAKE1 | python -mjson.tool

#	(very little)

#To filter results one the server side, simply separate additional filters with \& (or quote the entire URL, since "&" has special meaning in the shell).
curl http://dgidb.genome.wustl.edu/api/v1/interactions.json?genes=FLT3,STK1,FAKE1\&interaction_sources=TTD,DrugBank | python -mjson.tool

#	(less)

#Apply an additional filter to get only interactions with the tpye 'inhibitor'
curl http://dgidb.genome.wustl.edu/api/v1/interactions.json?genes=FLT3,STK1,FAKE1\&interaction_sources=TTD,DrugBank\&interaction_type=inhibitor | python -mjson.tool

#	(even less)

