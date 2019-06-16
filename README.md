# files-arranger

This program helps you to arrange your files in a better directory tree.
How to use it?

Prepare a file, where you describe your new directory tree. 

    Ex. file 'dreams_x_reality':
      /job	job
      /job/current	companyC
      /job/old	\(companyA\)|\(companyB\)
      /dreams	nonsense
      /dreams/work	money
      /dreams/women	love

and so on... 
Always there is the first part that desribes the a new directory, then a 'tab' and then there is a regex, that files have to match to be present in this file.
In our example all files, that matches "job" and "companyC" will be in the directory /job/current etc.

Choose the source directory. For example 'folders/with/all/useless/things'.

Use my program!

    files-arranger.sh 'folders/with/all/useless/things' 'dreams_x_reality'

But might you would like to have your new repository at some better place, so you may choose the one you want

    files-arranger.sh -d 'better/directory' 'folders/with/all/useless/things' 'dreams_x_reality'

If you would like to also have your nonmatching files in the file 'others', you may too:

    files-arranger.sh -o 'folders/with/all/useless/things' 'dreams_x_reality'

Also if you would like to to find your other useless files in subdirectories of the source directory, you should specify it:

    files-arranger.sh -r 'folders/with/all/useless/things' 'dreams_x_reality'

And if you are ever stucked or do not know, there is always possibilty to get help!

    files-arranger.sh -h

So do not wait and get my awesome files-arranger.sh!
