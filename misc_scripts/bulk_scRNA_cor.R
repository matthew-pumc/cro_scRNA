library(tidyverse)

exp <- read_table('../06.Data_Compare/bulk_rna/quant.tpm')
scexp <- read_csv('../06.Data_Compare/bulk_rna/cro2-3.sumexp.csv',
                  col_names = T)$sum
exp <- cbind(exp, scexp)


exp <- exp %>% rowwise() %>%
  mutate(prot_mean = mean(P1.TPM:P4.TPM),
         leaf_mean = mean(L1.TPM:L3.TPM))
calculate_r <- function(data, x, y){
  log_x <- log2(data[,x])
  log_y <- log2(data[,y])
  r <- cor(log_x, log_y, method = "s")
  sprintf("italic(R) == %.2f", r)
}

# choose 2 from 3 (prot_mean, leaf_mean, scexp)
r <- calculate_r(exp, "prot_mean", "leaf_mean")

ggplot(exp, aes(log2(prot_mean+1), log2(scexp+1))) +
  # geom_point() +
  geom_point(alpha = 0.2, stroke = 0, size = 2) +
  geom_smooth(method = lm, se=FALSE,colour = "#3182bd") +
  annotate("text",x=2,y=20, label=r, parse = TRUE) +
  theme_classic() +
  labs(x = "log2(protoplast expression + 1)",
       y = "log2(scRNA expression + 1)")
