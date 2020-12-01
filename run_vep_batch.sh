#!/bin/bash

#=================================================================================================#

GREEN='\033[92m'
YELLOW='\033[93m'
ENDC='\033[0m'
BOLD='\033[1m'

reference="/media/molmed/Data/Reference_Genome/gatk/Homo_sapiens_assembly38.fasta"
snpeff="/home/molmed/ngs/bin/snpEff/snpEff/snpEff.jar"
#=================================================================================================#
count=0
cat run_batch_VEP.txt | while read sampleID vcfFile;
do

count=$((count + 1))
echo "\n${BOLD}${YELLOW}Sample number runing: $count ${ENDC}\n"
echo "${BOLD}${GREEN}Sample ID: $sampleID ${ENDC}\n"
#=================================================================================================#
mkdir -p "output"/"$sampleID"
exec &> output/$sampleID.StdOp.Err.txt;
#=================================================================================================#
echo "${BOLD}${GREEN}Starting Run ==${ENDC}" `date +%d/%m/%Y\ %H:%M:%S` 2>> output/$sampleID.StdOp.Err.txt
gatk SelectVariants -R $reference -V ${vcfFile} -O output/$sampleID/${sampleID}_select_filtered.vcf -select 'vc.isNotFiltered()' 2>> output/$sampleID.StdOp.Err.txt
echo "GATK Variant filter runtime end" `date +%d/%m/%Y\ %H:%M:%S` 2>> output/$sampleID.StdOp.Err.txt

echo "SnpEff runtime start" `date +%d/%m/%Y\ %H:%M:%S` 2>> output/$sampleID.StdOp.Err.txt
java -jar $snpeff -canon GRCh38.86 output/$sampleID/${sampleID}_select_filtered.vcf >output/$sampleID/${sampleID}_select_filtered.ann.vcf 2>> output/$sampleID.StdOp.Err.txt
echo "SnpEff runtime end" `date +%d/%m/%Y\ %H:%M:%S` 2>> output/$sampleID.StdOp.Err.txt

echo "VEP runtime start" `date +%d/%m/%Y\ %H:%M:%S` 2>> output/$sampleID.StdOp.Err.txt
vep --offline --cache --dir_cache /home/molmed/.vep/vep_data/ --fasta /home/molmed/.vep/homo_sapiens/101_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --hgvs --hgvsg --protein --symbol --ccds --canonical --mane --uniprot --biotype --pubmed --sift b, --polyphen b --variant_class --total_length --numbers --af --af_gnomad -i output/$sampleID/${sampleID}_select_filtered.ann.vcf -o output/$sampleID/${sampleID}_select_filtered_ann_VEP.txt --tab output/$sampleID.StdOp.Err.txt
echo "VEP runtime end" `date +%d/%m/%Y\ %H:%M:%S` 2>> output/$sampleID.StdOp.Err.txt

echo "${BOLD}${GREEN}Ending Run ==${ENDC}" `date +%d/%m/%Y\ %H:%M:%S` 2>> output/$sampleID.StdOp.Err.txt

done
#=================================================================================================#
