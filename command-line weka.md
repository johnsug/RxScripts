Linux-Based Weka Cheat-Sheet:
1. Calling Weka
2. Select primary classifier
3. Select training data
4. Select testing data
5. Save results
6. Save predictions
7. Save model
8. Load model
9. Modify the parameters of the primary classifier
10. Add secondary classifiers
11. Increase heap size

1. To call Weka, you first must type "java" and then use the command path statement "-cp" to refer to where the Weka jar is located.  If you are in your home directory, you would do this by starting your code with:

java -cp ../data/weka/weka.jar <classifiers> <data> ...

2. After you've envoked the Weka jar, you can then select your primary classifier.  If you wanted to use J48, you would do so as follows:

java -cp ../data/weka/weka.jar weka.classifiers.trees.J48 <data> ...

3. Weka indicates the training data with "-t" and the testing data with "-T".  For example, to train a simple J48 tree, with default settings, on the segment-challenge data, one would run:

java -cp ../data/weka/weka.jar weka.classifiers.trees.J48 -t ../data/weka/data/segment-challenge.arff ...

4. To train and test the model, using segment-challenge and segment-test,

java -cp ../data/weka/weka.jar weka.classifiers.trees.J48 -t ../data/weka/data/segment-challenge.arff -T ../data/weka/data/segment-test.arff ...

If you do not call testing data, Weka will perform cross validation with the training dataset.

5. Then, to save the results, end the syntax with something like "> results.txt":

java -cp ../data/weka/weka.jar weka.classifiers.trees.J48 -t ../data/weka/data/segment-challenge.arff -T ../data/weka/data/segment-test.arff > results.txt

6. If you want to save the predictions, instead of the evaluation metrics, include "-p 0":

java -cp ../data/weka/weka.jar weka.classifiers.trees.J48 -t ../data/weka/data/segment-challenge.arff -T ../data/weka/data/segment-test.arff -p 0 > results.txt

7. To save your model run on your training data, replace the reference to your testing data the "-d <model_name.model>" option (d="dump"):

java -cp ../data/weka/weka.jar weka.classifiers.trees.J48 -t ../data/weka/data/segment-challenge.arff -d segment.model ...

8. Then, to run your model on your testing data, use the "-l <model.name" option (l="load") in place of your training data, and call your testing data:

java -cp ../data/weka/weka.jar weka.classifiers.trees.J48 -l segment.model -T ../data/weka/data/segment-test.arff

{color:red}_Note: it doesn't matter which classifier you call before loading the model.  Weka will not run if you don't call a classifier, but the classifier used here won't impact the model results.  If you modify the primary classifier with parameters, or add secondary classifiers, while developing your model, do not refer to the parameters or secondary classifiers while loading/running the saved model._{color}

9. To modify the parameters of your primary classifier, indicate them after referring to your data.  For example, if the Weka Explorer states you want to run "weka.classifiers.trees.J48 -C 0.25 -M 2", indicate it as follows:

java -cp ../data/weka/weka.jar weka.classifiers.trees.J48 -t ../data/weka/data/segment-challenge.arff -T ../data/weka/data/segment-test.arff -C 0.25 -M 2 ...

10. If you want to call secondary classifiers, refer to them with "-W" after your dataset(s) and your primary classifier's parameters.  (Note--the -W's will already be referenced if you copy code from the Weka Explorer.) For example, to run a bagged decision stump on the segment data: 

java -cp ../data/weka/weka.jar weka.classifiers.meta.Bagging -t ../data/weka/data/segment-challenge.arff -T ../data/weka/data/segment-test.arff -C 0.25 -M 2 -W weka.classifiers.trees.DecisionStump ...

11. Although it is not necessary, you will likely want to boost your heap space 1) so you don't run out of space, and 2) to take full advantage of the Linux boxes. Indicate your desired heap space by using "-Xmx <desired heap space>" after invoking java:

java -Xmx2048m -cp ../data/weka/weka.jar <classifiers> <data> ...

Helpful Resources
* Weka Command Line Primer: http://weka.wikispaces.com/Primer