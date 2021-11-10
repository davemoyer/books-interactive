library(tidyverse)


setwd("C:/Users/dmoyer.3SI/personal/books-interactive")

b <- read.csv('booklist.csv')
p <- read.csv('pullitzer.csv')

books <- b %>%
  rename(year_read = year,
         short_title = short.title,
         long_title = long.title) %>%
  mutate(across(c(short_title,author), str_trim))

pullitzer <- p %>%
  rename(year_award = year,
         category_award = category,
         short_title = short.title,
         long_title = long.title) %>%
  mutate(across(c(short_title,author), str_trim))

books_joined <- books %>%
  full_join(pullitzer, by = c('short_title','author')) %>%
  mutate(long_title = coalesce(long_title.x,long_title.y))

authors <- books_joined %>%
  select(starts_with('author')) %>%
  distinct()

write.csv(authors, "etl/authors.csv", row.names = F, na = "")

booklist <- books_joined %>%
  select(short_title,
         long_title,
         author,
         read,
         year_read,
         order_read = read.order,
         award,
         year_award,
         category_award) %>%
  mutate(read = ifelse(is.na(year_read),0,1),
         order_read = ifelse(read == 1, paste0(year_read,'-',order_read),NA_character_))

write.csv(booklist,"etl/booklist.csv",row.names = F, na = "")
