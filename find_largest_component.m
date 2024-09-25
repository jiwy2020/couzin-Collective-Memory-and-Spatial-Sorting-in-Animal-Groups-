function valid_points = find_largest_component(adj_matrix)
    % 创建图对象
    G = graph(adj_matrix);

    % 计算连通分量
    components = conncomp(G);

    % 计算每个连通分量的大小
    component_sizes = histcounts(components, 1:(max(components)+1));

    % 找到最大连通分量的索引
    [~, largest_component_idx] = max(component_sizes);

    % 标记最大连通分量中的点
    valid_points = components == largest_component_idx;
end
