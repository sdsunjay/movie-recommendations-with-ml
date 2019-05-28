awk '($9 ~ 403)' logs.txt | awk '{print $1}' | sort | uniq
