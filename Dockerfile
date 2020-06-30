# Using other maintained image 
FROM calpolydatascience/rstudio-base:1.0.2

# Dependancy installation 
USER root 
RUN apt-get update && \
    apt-get install libz-dev libncurses5-dev libncursesw5-dev libbz2-dev liblzma-dev cmake default-jdk python3-pip libtbb2 libcurl4-openssl-dev -y
USER jovyan 

#Setup environment 
ENV RNA_HOME=/home/jovyan/workspace/rnaseq
RUN mkdir -p ~/workspace/rnaseq/ && \
    mkdir $RNA_HOME/student_tools 

# SAMtools
RUN cd $RNA_HOME/student_tools/ && \
    wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
    bunzip2 samtools-1.9.tar.bz2 && \
    tar -xvf samtools-1.9.tar && \
    cd samtools-1.9 && \
    make && \
    rm -rf $RNA_HOME/student_tools/samtools-1.9.tar.bz2 && \
    rm -rf $RNA_HOME/student_tools/samtools-1.9.tar

# bam-readcount
RUN cd $RNA_HOME/student_tools/ && \
    export SAMTOOLS_ROOT=$RNA_HOME/student_tools/samtools-1.9 && \
    git clone https://github.com/genome/bam-readcount.git && \
    cd bam-readcount && \
    cmake -Wno-dev $RNA_HOME/student_tools/bam-readcount && \
    make 

# HISAT2 
RUN cd $RNA_HOME/student_tools/ && \
    wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip && \
    unzip hisat2-2.1.0-Linux_x86_64.zip && \
    rm -rf hisat2-2.1.0-Linux_x86_64.zip


# StringTie 
RUN cd $RNA_HOME/student_tools/ && \
    wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.4d.Linux_x86_64.tar.gz && \
    tar -xzvf stringtie-1.3.4d.Linux_x86_64.tar.gz && \
    rm -rf stringtie-1.3.4d.Linux_x86_64.tar.gz 

# gffcompare 
RUN cd $RNA_HOME/student_tools/ && \
    wget http://ccb.jhu.edu/software/stringtie/dl/gffcompare-0.10.6.Linux_x86_64.tar.gz && \
    tar -xzvf gffcompare-0.10.6.Linux_x86_64.tar.gz && \
    rm -rf gffcompare-0.10.6.Linux_x86_64.tar.gz

# htseq-count
RUN cd $RNA_HOME/student_tools/ && \
    wget https://github.com/simon-anders/htseq/archive/release_0.11.0.tar.gz && \
    tar -zxvf release_0.11.0.tar.gz && \
    cd htseq-release_0.11.0/ && \
    pip install numpy && \
    python setup.py install --user && \
    chmod +x scripts/htseq-count && \
    rm -rf $RNA_HOME/student_tools/release_0.11.0.tar.gz

# TopHat 
RUN cd $RNA_HOME/student_tools/ && \
    wget https://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz && \
    tar -zxvf tophat-2.1.1.Linux_x86_64.tar.gz && \
    rm -rf tophat-2.1.1.Linux_x86_64.tar.gz

# kallisto 
RUN cd $RNA_HOME/student_tools/ && \
    wget https://github.com/pachterlab/kallisto/releases/download/v0.44.0/kallisto_linux-v0.44.0.tar.gz && \
    tar -zxvf kallisto_linux-v0.44.0.tar.gz && \
    rm -rf kallisto_linux-v0.44.0.tar.gz 

# FastQC 
RUN cd $RNA_HOME/student_tools/ && \
    wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip --no-check-certificate && \
    unzip fastqc_v0.11.8.zip && \
    cd FastQC/ && \
    chmod 755 fastqc && \
    rm -rf $RNA_HOME/student_tools/fastqc_v0.11.8.zip

# Add desktop option -- needed for GUI applications 
USER root

RUN apt-get install -y dbus-x11 firefox xfce4 xfce4-panel xfce4-session xfce4-settings xorg xubuntu-icon-theme
ADD kioskrc /etc/xdg/xfce4/kiosk/kioskrc
ADD default.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
ADD desktop.png /usr/share/backgrounds/xfce/desktop.png
RUN cp /usr/share/backgrounds/xfce/desktop.png /usr/share/backgrounds/xfce/xfce-blue.jpg && \
    cp /usr/share/backgrounds/xfce/desktop.png /usr/share/backgrounds/xfce/xfce-teal.jpg
USER jovyan

RUN conda install -c manics websockify
RUN pip install jupyter-desktop-server

# MultiQC 
RUN pip install multiqc 

# Picard 
RUN cd $RNA_HOME/student_tools/ && \
    wget https://github.com/broadinstitute/picard/releases/download/2.18.15/picard.jar -O picard.jar

# Flexbar
RUN cd $RNA_HOME/student_tools/ && \
    wget https://github.com/seqan/flexbar/releases/download/v3.4.0/flexbar-3.4.0-linux.tar.gz && \
    tar -xzvf flexbar-3.4.0-linux.tar.gz && \
    cd flexbar-3.4.0-linux/ && \
    export LD_LIBRARY_PATH=$RNA_HOME/student_tools/flexbar-3.4.0-linux:$LD_LIBRARY_PATH && \
    rm -rf $RNA_HOME/student_tools/flexbar-3.4.0-linux.tar.gz

# Regtools 
RUN cd $RNA_HOME/student_tools/ && \
    git clone https://github.com/griffithlab/regtools && \
    cd regtools/ && \
    mkdir build && \
    cd build/ && \
    cmake .. && \
    make &&\ 
    echo "alias regtools=$RNA_HOME/student_tools/regtools/build/regtools" >> ~/.bashrc

# RSeQc
RUN pip install RSeQC

