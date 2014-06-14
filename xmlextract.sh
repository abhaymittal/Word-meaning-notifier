#This scripts extracts info of a word from the oxford english dictionary website
#Assume webpage is in 123.html

wrap_div=$(xmllint --html --xpath '//div[@class="responsive_cell_center"][1]' 123.html 2> /dev/null)
content_div=$(echo $wrap_div | xmllint --html --xpath '//div[@class="etymology"]/preceding-sibling::*' - 2> /dev/null)
echo $content_div >789.html
title=$(echo $content_div | xmllint --html --xpath '//h2[@class="pageTitle"]/text()' - 2> /dev/null)
echo $title > output.txt
echo -e "\n----------------------------" >> output.txt
main_content=$(echo $content_div | xmllint --html --xpath '//section[@class="etymology"]/preceding-sibling::section[@class="senseGroup"]' - 2> /dev/null)
echo $main_content > 456.html
count=$(echo $main_content | xmllint --html --xpath 'count(//section[@class="senseGroup"])' - 2> /dev/null)

for((i=1;i<=$count;i++))
do
    type=$(echo $main_content | xmllint --html --xpath "//section[@class='senseGroup'][$i]" - 2>/dev/null)
    echo $type > 789.html
    part_of_speech=$(echo $type | xmllint --html --xpath "//span[@class='partOfSpeech']/text()" - 2> /dev/null);
    echo -e "\n$part_of_speech" >> output.txt
    syn=$(echo $type | xmllint --html --xpath "//div[@class='synEntryList']" - 2> /dev/null)
    echo $syn
    
done

