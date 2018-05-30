# Climate change communication from cities in the USA
  
### Summary
This page provides the data and code necessary to replicate the statistical analysis in the following paper: 

	Constantine Boussalis, Travis G. Coan, and Mirya Holman. "Climate change communication from cities in the USA." Climatic Change, 2018.

### Dependencies

**Text classification**. The scripts needed to replicate the text classification described in Section 3.2 in the paper are located in the ./src directory and were tested in [Python 2.7](https://www.python.org/download/releases/2.7/). The following Python libraries are required:

* [NumPy](http://www.numpy.org/) (tested on version 1.14.0)
* [scikit-learn](http://scikit-learn.org/stable/) (tested on version 0.18.2)

**Statistical analysis**. The scripts needed to replicate the statistical analysis presented in Section 6 of the paper are located in the ./R directory and were tested in [R version 3.2.3](https://www.r-project.org/) (2015-12-10). The following R packages are required:

* [coda](https://cran.r-project.org/web/packages/coda/index.html) (tested on version 0.18-1)
* [brms](https://cran.r-project.org/web/packages/brms/index.html) (tested on version 0.9.0)
* (optional) [shinystan](http://mc-stan.org/users/interfaces/shinystan) (tested on version 2.2.1)

### Usage

**Text classification**. The classify.py file in the ./src directory carries out the support vector classifer described in the text. On *nix based machines, it's probably easiest to run the classify.py script from the terminal:

```
$ cd <root directory of repo>
$ python ./src/classify.py .
```

**Statistical analysis**. The replicate.R file in the ./R directory carries out the regression analysis described in the text. It's easiest run this code interactively. Please note that you will need to set the working directory (and modify paths if on Windows) in order to successfully execute the script. 
