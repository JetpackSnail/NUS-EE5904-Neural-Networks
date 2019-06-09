






%%
for i = 1:600
    min = inf;
    for j = 1:100
    diff = norm(train_data(:,i) - w(:,j));
    if diff < min
        min = diff;
        min_idx = j;
    end
    end
    train_grid(1,i) = reshaped_label(1,min_idx);
end
counter1 = 0;
for i = 1:600
    if train_grid(1,i) == train_classlabel(1,i)
        counter1 = counter1 + 1;
    end
end
train_acc = counter1/600;




