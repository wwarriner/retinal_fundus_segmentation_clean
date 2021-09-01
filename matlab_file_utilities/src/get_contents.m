function contents = get_contents( folder, recursive )

if nargin < 2
    recursive = "";
end

if ischar( folder )
    folder = string( folder );
end

assert( isstring( folder ) );
assert( isscalar( folder ) );
assert( isfolder( folder ) );

if ischar( recursive )
    recursive = string( recursive );
end

assert( isstring( recursive ) );
assert( isscalar( recursive ) );
recursive = lower( recursive );

if startsWith( "recursive", recursive )
    folder = fullfile( folder, "**" );    
end

contents = struct2table( dir( folder ) );
contents = remove_dots( contents );

end

