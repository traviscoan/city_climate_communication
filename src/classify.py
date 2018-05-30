#!/usr/bin/python

import sys, os
from matplotlib.font_manager import weight_as_number
reload(sys)  # Reload does the trick!
sys.setdefaultencoding('UTF-8')
import pickle

# Classification
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.svm import LinearSVC
from sklearn.calibration import CalibratedClassifierCV
from sklearn.model_selection import KFold
from sklearn.model_selection import cross_val_score

if __name__ == '__main__':
    
    # Change to specified source directory
    os.chdir(sys.argv[1])

    with open('./data/climate_press_releases_processed.pkl', 'r') as pfile:
        pcontent = pickle.load(pfile)
    
    # Parse 
    text = [row[0] for row in pcontent]
    codes = [row[1] for row in pcontent]
    
    # Vectorize
    print 'Running TF-IDF vectorizer...'
    vectorizer = TfidfVectorizer(ngram_range=(1,2))
    X = vectorizer.fit_transform(text)
    y = np.array(codes)
    
    # Subset training data
    keep = np.where(y[:] != 999) # get the index
    X_train = X[keep[0], :]
    y_train = y[keep[0]]
    
    # Cross-validation
    print 'Training support vector classifer...'
    svm = LinearSVC(C = 1.15) # based on grid search
    clf = CalibratedClassifierCV(svm) 
    kf = KFold(n_splits = 10, shuffle = True, random_state=624168)
    
    # F1 score
    f1_estimate = cross_val_score(clf, X_train, y_train, scoring='f1', cv = kf).mean()
    print 'F1 score based on 10 fold cross-validation = %s' % f1_estimate
    
    # Precision
    precision_estimate = cross_val_score(clf, X_train, y_train, scoring='precision', cv = kf).mean()
    print 'Precision based on 10 fold cross-validation = %s' % precision_estimate
    
    # Recall
    recall_estimate = cross_val_score(clf, X_train, y_train, scoring='recall', cv = kf).mean()
    print 'Recall based on 10 fold cross-validation = %s' % recall_estimate


# END
