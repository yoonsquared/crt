#!/bin/bash

#PBS -l walltime=10:00:00,nodes=1:ppn=10
#PBS -joe .
#PBS -d .
#PBS -l vmem=50g

#modified from bcbio rna-seq log and STAR manual
#https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf
# len = mate lengths - 1

len=`zcat $sample_1.fq.gz | head -n 2| tail -n1 | awk '{print length}'`

STAR --genomeDir /hpf/largeprojects/ccmbio/naumenko/tools/bcbio/genomes/Hsapiens/GRCh37/star/ \
    --readFilesIn $sample_1.fq.gz $sample_2.fq.gz \
    --twopassMode Basic \
     --runThreadN 10 \
     --outFileNamePrefix $sample \
     --outReadsUnmapped Fastx \
     --outFilterMultimapNmax 10 \
     --outStd SAM  \
     --outSAMunmapped Within \
     --outSAMattributes NH HI NM MD AS  \
     --sjdbGTFfile /hpf/largeprojects/ccmbio/naumenko/tools/bcbio/genomes/Hsapiens/GRCh37/rnaseq/ref-transcripts.gtf \
     --sjdbOverhang $len  --readFilesCommand zcat  --outSAMattrRGline ID:$sample PL:illumina PU:$sample SM:ID  \
     | samtools sort -@ 5 -m 1G  -T . \
     -o $sample.bam /dev/stdin
