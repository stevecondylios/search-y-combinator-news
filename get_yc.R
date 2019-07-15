
library(rvest)
library(dplyr)

yc <- data.frame(yc_article_titles=character(), yc_links=character())

for (i in 1:100) {
  print(paste0("Scraping page ", i))
  yc_url <- paste0("https://news.ycombinator.com/news?p=", i)
  
  containers <- read_html(yc_url) %>% html_nodes("a.storylink") 
  
  if(length(containers) == 0) { 
    cat(paste0("\033[0;33m", "Done scraping ", nrow(yc), " links", "\033[0m","\n"))
    break 
    }
  
  yc_article_titles <- containers %>% html_text
  
  yc_links <- containers %>% html_attr("href") %>% 
    { ifelse(substr(., 1, 5) == "item?", 
      paste0("https://news.ycombinator.com/", .),
      . ) }
  

  yc <- rbind(yc, data.frame(yc_article_titles, yc_links, stringsAsFactors = FALSE))
  
  
}

# Find articles with a particular term (e.g. "google")
"google" %>% grep(., yc$yc_article_titles, ignore.case = TRUE, value = TRUE) 
"google" %>% grep(., yc$yc_article_titles, ignore.case = TRUE, value = TRUE) %>% 
  { which(yc$yc_article_titles %in% .) } %>% yc[., ]
