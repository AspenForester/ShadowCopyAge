# ShadowCopyAge
Returns the age in days of the oldest shadow copy for each volume on a given server.

I happen to have a number of file servers that I manage, and each has a number of volumes with one or more shares.
I like to have 30 days' worth of shadow copies for each volume.  Obviously, trying to manage that through the 
point and click GUI interface (where there is no remote option yet) wasn't going to suffice.  I figured I start with 
getting the age of the oldest shadow copy for each volume volume.

Then I decided maybe I should track the development of the function in git.
