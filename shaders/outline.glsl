extern vec2 stepSize;

vec4 effect(vec4 col, Image texture, vec2 texturePos, vec2 screenPos) {
  vec4 texturePixel = texture2D( texture, texturePos );
  number alpha = texturePixel.a * 4.;
  alpha -= texture2D(texture, texturePos + vec2(-stepSize.x, 0.)).a;
  alpha -= texture2D(texture, texturePos + vec2(stepSize.x, 0.)).a;
  alpha -= texture2D(texture, texturePos + vec2(0.0, -stepSize.y)).a;
  alpha -= texture2D(texture, texturePos + vec2(0.0, stepSize.y)).a;
  return vec4(vec3(1.), alpha);
}
