function visualize_simulation(C, V, t, x_lim, y_lim, z_lim, centroid_history)
    % 可视化个体位置和方向，并显示当前坐标轴范围内的个体数量
    % 并绘制新质心的轨迹

    figure(1);
    clf;
    hold on;
    axis equal;
    grid on;
    title(['t = ', num2str(t)]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    % 3D箭头绘制个体方向
    quiver3(C(:, 1), C(:, 2), C(:, 3), V(:, 1), V(:, 2), V(:, 3), 0, 'k', 'LineWidth', 1, 'MaxHeadSize', 1);
    
    % 绘制新质心的轨迹
    plot3(centroid_history(:, 1), centroid_history(:, 2), centroid_history(:, 3), 'r-', 'LineWidth', 2);
    
    % 在图中标注最新的质心位置
    new_centroid = centroid_history(end, :);
    plot3(new_centroid(1), new_centroid(2), new_centroid(3), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    
    view(3); % 设置为三维视角
    camproj('perspective'); % 透视投影

    % 根据新质心调整坐标轴范围
    xlim(new_centroid(1) + x_lim);
    ylim(new_centroid(2) + y_lim);
    zlim(new_centroid(3) + z_lim);

    drawnow; % 实时刷新图像
end
