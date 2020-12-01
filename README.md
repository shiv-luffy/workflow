Script to run VEP on vcf files

Usage:
```  
sh run_vep_batch.sh
```

To install VEP:
Download the repo
```
git clone https://github.com/Ensembl/ensembl-vep.git
```
Install
```
cd ensembl-vep
perl INSTALL.pl
```
Test
```
./vep -i examples/homo_sapiens_GRCh38.vcf --cache
```

To run the script add sample ID and vcf file names a tab separated txt file called ```run_batch_VEP.txt```
copy the file into pwd or give absolute path for the files and edit the path for the reference and the jar file
