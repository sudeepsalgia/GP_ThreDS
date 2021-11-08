function [accuracy, t] = f(params)

    global train_x;
    global train_y;
    global test_x;
    global test_y;
    global val_x;
    global val_y;

layers = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(params(2), 10)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(params(3), 20)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    fullyConnectedLayer(params(4))
    reluLayer
    
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];


    options = trainingOptions('sgdm', ...
    'InitialLearnRate',params(5), ...
    'MaxEpochs',3, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{val_x, val_y}, ...
    'ValidationFrequency',20, ...
    'MiniBatchSize', params(1), ...
    'Verbose',false);
    
    time_function = tic;

    net = trainNetwork(train_x, train_y,layers,options);
   
    
    YPred = classify(net,test_x);

    accuracy = sum(YPred == test_y)/numel(test_y);
    
    t = toc(time_function);
end

