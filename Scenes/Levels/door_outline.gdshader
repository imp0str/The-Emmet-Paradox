shader_type canvas_item;

uniform float outline_thickness = 2.0;
uniform vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    float dx = min(UV.x, 1.0 - UV.x);
    float dy = min(UV.y, 1.0 - UV.y);
    float dist = min(dx, dy) * 64.0; // since 64x64 texture

    if (dist <= outline_thickness) {
        COLOR = outline_color;
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0); // fully transparent
    }
}
