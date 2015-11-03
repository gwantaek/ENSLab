function fig_cortex_6view(mesh, X, scale)

if isempty(scale)
    scale = [min(X) max(X) * 0.7];
end

set(gcf,'nextplot','add', 'Color',[1 1 1]);

subplot(2,3,1); fig_cortex_top(mesh,X,scale); title('Top');
subplot(2,3,2); fig_cortex_left(mesh,X,scale); title('Left');
subplot(2,3,3); fig_cortex_front(mesh,X,scale); title('Front');
subplot(2,3,4); fig_cortex_bottom(mesh,X,scale); title('Bottom');
subplot(2,3,5); fig_cortex_right(mesh,X,scale); title('Right');
subplot(2,3,6); fig_cortex_back(mesh,X,scale); title('Back');

end