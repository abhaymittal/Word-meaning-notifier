#! /bin/bash
#This scripts extracts info of a word from the oxford english dictionary website
#Assume webpage is in 123.html

start="<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /></head><body>"

echo $start > output.html
wrap_div=$(xmllint --html --xpath '//div[@class="responsive_cell_center"][1]' 123.html 2> /dev/null)
wrap_div="$start $wrap_div </body></html>"
content_div=$(echo $wrap_div | xmllint --html --xpath '//div[@class="etymology"]/preceding-sibling::*' - 2> /dev/null)
content_div="$start $content_div </body></html>"
echo $content_div > 789.html
title=$(echo $content_div | xmllint --html --xpath '//h2[@class="pageTitle"]/text()' - 2> /dev/null)
echo "<h1>$title</h1>" >> output.html
syllabi=$(echo $content_div | xmllint --html --xpath '//span[@class="headsyllabified"]' - 2> /dev/null)
echo $syllabi >> output.html
echo -e "<p>----------------------------</p>" >> output.txt
main_content=$(echo $content_div | xmllint --html --xpath '//section[@class="etymology"]/preceding-sibling::section[@class="senseGroup"]' - 2> /dev/null)
main_content="$start $main_content </body></html>"
echo $main_content > 456.html
count=$(echo $main_content | xmllint --html --xpath 'count(//section[@class="senseGroup"])' - 2> /dev/null)

for((i=1;i<=$count;i++))
do
    type=$(echo $main_content | xmllint --html --xpath "//section[@class='senseGroup'][$i]" - 2>/dev/null)
    type="$start $type </body></html>"
    part_of_speech=$(echo $type | xmllint --html --xpath "//span[@class='partOfSpeech']/text()" - 2> /dev/null)
    pronun=$(echo $type | xmllint --html --xpath "//div[@class='headpron']/text()" - 2> /dev/null)
    echo "<br><span>Pronunciation: <b>$pronun</b></span>" >> output.html
    echo -e "<h4>$part_of_speech</h4>" >> output.html
    trans_stat=$(echo $type | xmllint --html --xpath "//em[@class='transivityStatement']/text()" - 2> /dev/null)
    echo -e "<span>[ $trans_stat]</span>" >> output.html
    sense_entry_ct=$(echo $type | xmllint --html --xpath "count(//section[@class='senseGroup']/ul)" - 2> /dev/null)
    for((j=1;j<=$sense_entry_ct;j++))
    do
	li_sense_ct=$(echo $type | xmllint --html --xpath "count(//section[@class='senseGroup']/ul[$j]/li)" - 2>/dev/null)
	for((k=1;k<=li_sense_ct;k++))
	do
	    li_sense=$(echo $type | xmllint --html --xpath "//section[@class='senseGroup']/ul[$j]/li" - 2>/dev/null)
	    li_sense="$start $li_sense </body></html>"
	    iteration=$(echo $li_sense | xmllint --html --xpath "//span[@class='iteration']/text()" - 2> /dev/null)
	    definition=$(echo $li_sense | xmllint --html --xpath "//span[@class='definition']/text()" - 2> /dev/null)
	    echo -e "<p>$iteration\t<b>$definition</b></p>" >> output.html
 	    example_main_ct=$(echo $li_sense | xmllint --html --xpath "count(//span/em[@class='example'])" - 2> /dev/null);
	    for((l=1;l<=example_main_ct;l++))
	    do
		example_main=$(echo $li_sense | xmllint --html --xpath "//span/em[@class='example'][$l]" - 2> /dev/null);
		echo -e "$example_main\n" >> output.html
	    done
	    sent_dictionary=$(echo $li_sense | xmllint --html --xpath "//ul[@class='sentence_dictionary']" - 2> /dev/null);
	    echo $sent_dictionary >> output.html
	done

    done

    echo -e "<p>\n\n-----------------------------------------------------------------\n\n</p>" >> output.html
    
done

echo "</body></html>" >> output.html
