folder=${2:-"texLog"}

createLogFolder() {
    if ! [ -d $folder ];then
        mkdir $folder
    fi
}

compile() {
    if [ -f $1 ];then
        latexmk -pdf $1 
    else
        echo "No such file. Exiting..."
        exit 1
    fi
    if [ $? -ne 0 ];then
        echo "Could not compile."
        exit 1
    fi
}

printLog(){
    logName=$(echo "$1" | cut -d"." -f1)
    if [ -f "$logName.log" ];then 
        cat "$logName.log"
    fi
}

moveFiles(){
    files=$(ls | grep -vw "$0\|.*\.tex\|.*\.pdf")
    echo "Moved files"
    for i in $files;do
        if [ -f $i ];then
            echo "$i"
            mv $i "$1"
        fi
    done
}

showPdf() {
    pdfName=$(echo "$1" |cut -d"." -f1)
    fullFile="$pdfName.pdf"
    if [ -f $fullFile ];then
        evince $fullFile &
    else
        echo "Error. Can't show PDF"
        exit 2
    fi
}

compile $1
createLogFolder $folder
printLog 
moveFiles $folder
showPdf $1

