A Random Forest Classifier for Multi-type Functional (RFCMFND)!
===================

**Package**: RFCMFND

**Type**: Package

**Title**: A Random Forest Classifier for Multi-type Functional Neuroimaging Data

**Version**: 0.1

**Date**: 2015-12-18

**Author(s)**: Nima Salehi Sadghiani, Amirhossein Meisami, Jian Kang

**Description**: In this package, we propose a modified **Random Forest (RF)** classifier for multi-type functional neuroimaging data (**foci**) and a **K-Centroids Cluster Analysis (KCCA)** algorithm to pre-process the foci.

**License**: University of Michigan

**LazyData**: TRUE

**RoxygenNote**: 5.0.1

----------


Help File
-------------
**imagePred {RFCMFND}**

> - **Description**: Prediction of the new dataset using the trained object time.
> - **Usage**: imagePred(train, data)
> - **Arguments**: 
>> - **train**: An object of class imageTrain.
>> - **data**: A n by 5 data.frame representing n observations in 5 dimensions.

> - **Value**: 
>> - **pred **: The prediction array.

> - **Warning**: The NewData data.frame should be processed with the exact same options as the training dataset.

> - **Examples**: 
>> - imagePred(train@Model, NewData)
>> - imagePred(train@Model, imagePreProc (data, clusters=5, freq=TRUE,distorg=TRUE, dist=TRUE, cov=TRUE))


**imagePreProc {RFCMFND}**

> - **Description**: Defining new variables, running the KCCA.
> - **Usage**: imagePreProc(data, clusters = 0, freq = TRUE, distorg = TRUE, dist = TRUE, cov = TRUE)
> - **Arguments**: 
>> - **data**:  A n by 5 data.frame representing n observations in 5 dimensions.
>> - **clusters**: An Integer value for the number of clusters. The default value is 0.
>> - **freq**:  If freq=TRUE, the frequency column is added to the current input dataset.
>> - **distorg**: If distorg=TRUE, the distance to origin column is added to the current input dataset.
>> - **dist**:  If dist=TRUE, the distance among points for each study is added to the current input dataset.
>> - **cov**: If cov=TRUE, the covariances (XY, XZ, YZ) columns are added to the current input dataset.

> - **Value**: 
>> - **dfg**: A data.frame of the pre-processed inputs.

> - **See Also**: 
>> -  https://cran.r-project.org/web/packages/flexclust/index.html

> - **Examples**: 
>> - imagePreProc (data, clusters=5, freq=TRUE,distorg=TRUE, dist=TRUE, cov=TRUE)


**imageTrain {RFCMFND}	**

> - **Description**: A modified version of RF classifier.
> - **Usage**: imageTrain(data, cparallel = FALSE, accuracy = FALSE)
> - **Arguments**: 
>> - **data**:  A data.frame of the pre-processed inputs.
>> - **cparallel**: If cparallel=TRUE, the RCPP Random Forest Classifier runs with parallel cores.
>> - **accuracy**:  If accuracy=TRUE, the accuracy of the classifier is shown.

> - **Value**:  Model and acc, a list in which the first element is the model object (named “Model”) and the second element is the list of accuracies across the classes (named “acc”).

> - **See Also**: 
>> - https://cran.r-project.org/web/packages/randomForest/index.html
>> - https://cran.r-project.org/web/packages/caret/index.html
>> - https://cran.r-project.org/web/packages/Rborist/index.html

> - **Examples**: 
>> - imageTrain(data, cparallel=TRUE, accuracy=TRUE)
