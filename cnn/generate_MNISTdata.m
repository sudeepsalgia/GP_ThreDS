function [training_imgs, training_labels, test_imgs, test_labels, validation_imgs, validation_labels] = generate_MNISTdata()

training_labels = zeros(10000, 1);
training_imgs = zeros(28, 28, 1, 10000);

validation_labels = zeros(2000, 1);
validation_imgs = zeros(28, 28, 1, 2000);

for i = 1:10
    idxs = find(y_train == i-1);
    idxs_train = idxs(1:1000);
    training_labels(((i-1)*1000 + 1):(i*1000)) = i-1;
    validation_labels(((i-1)*200 + 1):(i*200)) = i-1;
    for j = 1:1000
        training_imgs(:, :, :, ((i-1)*1000 + j)) = double(reshape(x_train(idxs_train(j), :), [28, 28, 1])');
    end
    idxs_validation = idxs(1001:1200);
    for j = 1:200
        validation_imgs(:, :, :, ((i-1)*200 + j)) = double(reshape(x_train(idxs_validation(j), :), [28, 28, 1])');
    end
end

test_labels = zeros(5000, 1);
test_imgs = zeros(28,28,1,5000);

for i = 1:10
    idxs = find(y_test == i-1);
    idxs = idxs(1:500);
    test_labels(((i-1)*500 + 1):(i*500)) = i-1;
    for j = 1:500
        test_imgs(:, :, :, ((i-1)*500 + j)) = double(reshape(x_test(idxs(j), :), [28, 28, 1])');
    end
end

perm_idxs = randperm(10000);
training_labels = training_labels(perm_idxs);
training_imgs = training_imgs(:, :, :, perm_idxs);

training_labels = categorical(training_labels);
test_labels = categorical(test_labels);
validation_labels = categorical(validation_labels);

end