input_file = File.read('./24.input').split

# input_file = <<~TEXT.split
# sesenwnenenewseeswwswswwnenewsewsw
# neeenesenwnwwswnenewnwwsewnenwseswesw
# seswneswswsenwwnwse
# nwnwneseeswswnenewneswwnewseswneseene
# swweswneswnenwsewnwneneseenw
# eesenwseswswnenwswnwnwsewwnwsene
# sewnenenenesenwsewnenwwwse
# wenwwweseeeweswwwnwwe
# wsweesenenewnwwnwsenewsenwwsesesenwne
# neeswseenwwswnwswswnw
# nenwswwsewswnenenewsenwsenwnesesenew
# enewnwewneswsewnwswenweswnenwsenwsw
# sweneswneswneneenwnewenewwneswswnese
# swwesenesewenwneswnwwneseswwne
# enesenwswwswneneswsenwnewswseenwsese
# wnwnesenesenenwwnenwsewesewsesesew
# nenewswnwewswnenesenwnesewesw
# eneswnwswnwsenenwnwnwwseeswneewsenese
# neswnwewnwnwseenwseesewsenwsweewe
# wseweeenwnesenwwwswnew
# TEXT

tiles = {}

input_file.each do |tile|
  coordinates = { x: 0.0, y: 0.0 }
  i = 0
  loop do
    break if i > tile.size - 1

    if %w[n s].include? tile[i]
      direction = tile[i..i + 1]
      i += 2
    else
      direction = tile[i]
      i += 1
    end
    case direction
    when 'e'
      coordinates[:x] += 1
    when 'w'
      coordinates[:x] -= 1
    when 'se'
      coordinates[:x] += 0.5
      coordinates[:y] -= 1
    when 'nw'
      coordinates[:x] -= 0.5
      coordinates[:y] += 1
    when 'ne'
      coordinates[:x] += 0.5
      coordinates[:y] += 1
    when 'sw'
      coordinates[:x] -= 0.5
      coordinates[:y] -= 1
    end
  end
  tiles[coordinates] ||= 0
  tiles[coordinates] += 1
end

black_tiles = tiles.select { |_, v| (v % 2).odd? }
pp black_tiles.count

def neighbours(tile)
  [
    { x: tile[:x] + 0.5, y: tile[:y] + 1 },
    { x: tile[:x] + 0.5, y: tile[:y] - 1 },
    { x: tile[:x] - 0.5, y: tile[:y] + 1 },
    { x: tile[:x] - 0.5, y: tile[:y] - 1 },
    { x: tile[:x] + 1, y: tile[:y] },
    { x: tile[:x] - 1, y: tile[:y] }
  ]
end

def count_black_neighbours(tiles, tile)
  tiles.keys.count { |k| neighbours(tile).include? k }
end

floor = black_tiles.clone
now = Time.now
100.times do |i|
  # pp "day #{i}: #{floor.count} (#{Time.now - now})" if (i % 10).zero?

  cache = {}

  new_floor = floor.clone
  new_floor.keys.each do |tile|
    neighbours(tile).each do |neighbour|
      next unless floor[neighbour].nil?

      cache[neighbour] = count_black_neighbours(floor, neighbour) if cache[neighbour].nil?
      black_neughbours = cache[neighbour]

      new_floor[neighbour] = 1 if black_neughbours == 2
    end

    cache[tile] = count_black_neighbours(floor, tile) if cache[tile].nil?
    black_neighbours = cache[tile]

    new_floor.delete tile if black_neighbours.zero? || black_neighbours > 2
  end

  floor = new_floor
end

pp floor.count
