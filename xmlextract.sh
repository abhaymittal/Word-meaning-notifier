#This scripts extracts info of a word from the oxford english dictionary website
#Assume webpage is in 123.html

wrap_div=$(xmllint --html --xpath '//div[@class="responsive_cell_center"][1]' 123.html 2> /dev/null)
content_div=$(echo $wrap_div | xmllint --html --xpath '//div[@class="etymology"]/preceding-sibling::*' - 2> /dev/null)
echo $content_div >789.html
title=$(echo $content_div | xmllint --html --xpath '//h2[@class="pageTitle"]/text()' - 2> /dev/null)
echo "<h1>$title</h1>"> output.html
echo -e "\n<p>----------------------------</p>" >> output.html
main_content=$(echo $content_div | xmllint --html --xpath '//section[@class="etymology"]/preceding-sibling::section[@class="senseGroup"]' - 2> /dev/null)
echo $main_content > 456.html
count=$(echo $main_content | xmllint --html --xpath 'count(//section[@class="senseGroup"])' - 2> /dev/null)

for((i=1;i<=$count;i++))
do
    type=$(echo $main_content | xmllint --html --xpath "//section[@class='senseGroup'][$i]" - 2>/dev/null)
    echo $type > 789.html
    part_of_speech=$(echo $type | xmllint --html --xpath "//span[@class='partOfSpeech']/text()" - 2> /dev/null)
    echo -e "\n$part_of_speech" >> output.txt
    trans_stat=$(echo $type | xmllint --html --xpath "//em[@class='transivityStatement']/text()" - 2> /dev/null)
    echo -e "\n$trans_stat" >> output.txt
    sense_entry_ct=$(echo $type | xmllint --html --xpath "count(//section[@class='senseGroup']/ul)" - 2> /dev/null)
    for((j=1;j<=$sense_entry_ct;j++))
    do
	li_sense_ct=$(echo $type | xmllint --html --xpath "count(//section[@class='senseGroup']/ul[$j]/li)" - 2>/dev/null)
	for((k=1;k<=li_sense_ct;k++))
	do
	    li_sense=$(echo $type | xmllint --html --xpath "//section[@class='senseGroup']/ul[$j]/li" - 2>/dev/null)
	    iteration=$(echo $li_sense | xmllint --html --xpath "//span[@class='iteration']/text()" - 2> /dev/null)
	    definition=$(echo $li_sense | xmllint --html --xpath "//span[@class='definition']/text()" - 2> /dev/null)
	    echo -e "$iteration\t$definition"
	    example_main=$(echo $li_sense | xmllint --html --xpath "//span/em[@class='example']" - 2> /dev/null);
	    echo $example_main
	    sent_dictionary=$(echo $li_sense | xmllint --html --xpath "//ul[@class='sentence_dictionary']" - 2> /dev/null);
	    echo $sent_dictionary > 890.html
	done

    done

    echo -e "\n\n-----------------------------------------------------------------\n\n" >> output.txt
    
done

