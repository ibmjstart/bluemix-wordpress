How to contribute to the plugins for jstart team members.

Contributing the the Object Storage Plugin:  
Note: There are two repos you might be looking for.
1. [wp-bluemix-objectstorage](https://github.com/ibmjstart/wp-bluemix-objectstorage) - This is the working version
for the newest IBM Object storage and WordPress 4.4.
  * You should only edit this if a new bug has been found and you need to
    make a quick fix.
1. [wp-openstack-objectstorage](https://github.com/ibmjstart/wp-openstack-objectstorage) - This is the new repo
for the newest features from the WP Offload S3 plugin as well as IBM Object Storage and Wordpress 4.4.
  * You should begin work here so that our wordpress on bluemix app can have the most up to date features
from the WP Offload S3 plugin.
  * Im not entirely sure what you have to change so that the app knows to use the wp-openstack-objectstorage repo instead
of the wp-bluemix-objectstorage repo, but i think you have to edit the composer.json in the repo itself, the composer.json
in the wordpress-on-bluemix app, and the ibmjstart/wp-bluemix-config repo.


Both of these projects employ github releases and git tags. That means, if you want to develop in the code,
there are a couple changes you need to make in order to see your changes.  
Note: A \* in the require section (like this `"ibmjstart/wp-bluemix-objectstorage" : "*"`) tells composer to use any 
version it finds, and the statement `prefer-stable:true` at the end of the composer.json tells it to only 
use the latest release.

Option 1 - Work in a new branch:  
1. Create a new branch on the git hub repo
1. Go to the composer.json in your wordpress-on-bluemix project
1. Edit the require section to point to your branch.  
```
  "require": {
        "ibmjstart/wp-bluemix-objectstorage" : "dev-<Your Branch>",
  },  
    ```
1. Merge your branch with the master.
1. In github (or through git), create a new release with a tag; this will document your changes and mark them 
as latest so they will be used. Look [here](https://github.com/ibmjstart/wp-bluemix-objectstorage/releases) for 
an example.

Option 2 - Work in the master branch:  
* I dont necessarily recommend this option, becuase the master should be kept clean and in the worst case something 
could go wrong and mess stuff up.  
* But, theoretically, using a version/tag system, you could make your changes in master, then 
once complete, add a new release/tag so that your changes are seen as latest.  

* Similar to before, you just have to make this change to the require block so you can see your changes during development.
```
  "require": {
        "ibmjstart/wp-bluemix-objectstorage" : "dev-master",
  }, ```  

