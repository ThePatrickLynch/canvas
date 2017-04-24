######
#
# Read canvas requests file and strip uneeded fields to reduce size
# processed in 3M chunks
#
######


rm(list=ls()) # just clear everything
setwd("D:/canvas/unpackedFiles")
myFile <- "requests_001(725).txt"
outFile <- "requests processed"
thisoutFile <- "requests_001(725).csv"
remove <- c(1,3:5,8:9,16,22,24:27)
rec.skip <- 0                   # starting point
rec.chunksize <- 10       # number of records in each chunk


canvasrequest <- read.table(myFile, sep='\t', na.strings="\\N", quote='"', fill=TRUE) 

canvasrequest <- canvasrequest[ -c(remove)] # strip unwanted columns
colnames(canvasrequest) = c("timestamp", "user_id", "course_id", "quiz_id", "discussion_id", "conversation_id", 
                        "assignment_id", "url", "user_agent", "remote_ip","interaction_micros", "web_application_controller", 
                        "web_application_action", "web_application_context_type","real_user_id")
# strip unwanted rows

canvasrequest <- subset(canvasrequest, !is.na(canvasrequest$user_id)) # no user identified
canvasrequest <- subset(canvasrequest, canvasrequest$web_application_controller!="accounts") # not account management
canvasrequest <- subset(canvasrequest, canvasrequest$web_application_action!="masquerade") # not changing to masquerade
canvasrequest$real_user_id <- NULL # not masquerades



write.table(canvasrequest, thisoutFile, sep=",", row.names = FALSE, col.names = FALSE, append = FALSE)




i <- 1

for (i in 1:1){
  # Read next chunk
  rec.skip <- rec.skip + rec.chunksize + 1
  thisoutFile <- capture.output(cat(outFile, i, ".csv"))    # new file for each chunk
  canvasrequest <- read.table(myFile, sep='\t', na.strings="\\N", quote='"', fill=TRUE, skip=rec.skip, nrows=rec.chunksize) 
  
  #colnames(canvasrequest) = c("timestamp", "user_id", "course_id", "quiz_id", "discussion_id", "conversation_id", 
  #                        "assignment_id", "url", "user_agent", "remote_ip","interaction_micros", "web_application_controller", 
  #                        "web_applicaiton_action", "web_application_context_type","real_user_id")
  
#  canvasrequest <- canvasrequest[ -c(remove)] # strip unwanted
  # write.table(canvasrequest, thisoutFile, sep=",", row_names = FALSE, col.names = FALSE, append = TRUE)

}






