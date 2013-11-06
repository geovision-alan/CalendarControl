//
//  AFConfiguration.h
//  AFConfiguration
//
//  Created by alantseng on 7/9/13.
//  Copyright (c) 2013 Geovision. All rights reserved.
//

#ifndef AFConfiguration_h
#define AFConfiguration_h

static float const k_default_calendar_key_title_background_color_begin[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_key_title_background_color_middle[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_key_title_background_color_end[4] = {1.0f, 1.0f, 1.0f, 1.0f};

static float const k_default_calendar_non_key_title_background_color_begin[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_non_key_title_background_color_end[4] = {1.0f, 1.0f, 1.0f, 1.0f};

static float const k_default_calendar_title_background_color_angle = -90.0f;
static float const k_default_calendar_title_text_color[4] = {0.0f, 0.0f, 0.0f, 1.0f};

static float const k_default_calendar_title_shadow_color[4] = {1.0f, 1.0f, 1.0f, 0.0f};
static float const k_default_calendar_title_shadow_offset[2] = {0.0f, -1.0f};
static float const k_default_calendar_title_shadow_blur_radius = 3.0f;

static float const k_default_calendar_background_path_color[4] = {0.5f, 0.5f, 0.5f, 1.0f};
static float const k_default_calendar_background_path_width = 2.0f;

static NSString* const k_default_calendar_month_year_font_name = @"Helvetica Bold";
static float const k_default_calendar_month_year_font_size = 12.0f;
static NSString* const k_default_calendar_week_day_font_name = @"Helvetica Bold";
static float const k_default_calendar_week_day_font_size = 12.0f;
static NSString* const k_default_calendar_month_day_font_name = @"Helvetica Bold";
static float const k_default_calendar_month_day_font_size = 14.0f;

static float const k_default_calendar_grid_path_shadow_color[4] = {1.0f, 1.0f, 1.0f, 0.0f};
static float const k_default_calendar_key_grid_path_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_non_key_grid_path_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};

static float const k_default_calendar_select_grid_text_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_today_grid_text_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_enable_grid_text_color[4] = {0.0f, 0.0f, 0.0f, 1.0f};
static float const k_default_calendar_disable_grid_text_color[4] = {0.5f, 0.5f, 0.5f, 0.5f};
static float const k_default_calendar_select_grid_shadow_color[4] = {0.2f, 0.2f, 0.2f, 1.0f};
static float const k_default_calendar_today_grid_shadow_color[4] = {0.2f, 0.2f, 0.2f, 1.0f};
static float const k_default_calendar_enable_grid_shadow_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_disable_grid_shadow_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_grid_shadow_offset[2] = {0.0f, 0.0f};
static float const k_default_calendar_grid_shadow_blur_radius = 1.0f;
static float const k_default_calendar_today_grid_interior_shadow_color[4] = {0.5f, 0.5f, 0.0f, 0.5f};
static float const k_default_calendar_today_grid_interior_shadow_offset[4] = {30.0f, 30.0f, 30.0f, 25.0f};
static float const k_default_calendar_today_grid_interior_shadow_radius = 2.0f;

static float const k_default_calendar_key_grid_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_key_today_grid_color[4] = {0.9f, 0.8f, 0.0f, 1.0f};
static float const k_default_calendar_key_today_and_selected_grid_color[4] = {19.0f/255.0f, 36.0f/255.0f, 168.0f/255.0f, 1.0f};
static float const k_default_calendar_non_key_grid_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_non_key_today_grid_color[4] = {0.5f, 0.4f, 0.0f, 1.0f};
static float const k_default_calendar_non_key_today_and_selected_grid_color[4] = {11.0f/255.0f, 25.0f/255.0f, 128.0f/255.0f, 1.0f};

static float const k_default_calendar_key_selected_grid_base_color[4] = {41.0f/255.0f, 122.0f/255.0f, 214.0f/255.0f, 1.0f};
static float const k_default_calendar_key_selected_grid_base_highlight_color[4] = {66.0f/255.0f, 141.0f/255.0f, 227.0f/255.0f, 1.0f};
static float const k_default_calendar_key_selected_grid_final_highlight_color[4] = {78.0f/255.0f, 151.0f/255.0f, 233.0f/255.0f, 1.0f};
static float const k_default_calendar_key_selected_grid_base_color_location = 0.0f;
static float const k_default_calendar_key_selected_grid_base_highlight_color_location = 0.5f;
static float const k_default_calendar_key_selected_grid_final_highlight_color_location = 1.0f;
static float const k_default_calendar_key_selected_grid_color_angle = 90.0f;

static float const k_default_calendar_non_key_selected_grid_base_color[4] = {21.0f/255.0f, 102.0f/255.0f, 194.0f/255.0f, 1.0f};
static float const k_default_calendar_non_key_selected_grid_base_highlight_color[4] = {46.0f/255.0f, 121.0f/255.0f, 207.0f/255.0f, 1.0f};
static float const k_default_calendar_non_key_selected_grid_final_highlight_color[4] = {58.0f/255.0f, 131.0f/255.0f, 213.0f/255.0f, 1.0f};
static float const k_default_calendar_non_key_selected_grid_base_color_location = 0.0f;
static float const k_default_calendar_non_key_selected_grid_base_highlight_color_location = 0.5f;
static float const k_default_calendar_non_key_selected_grid_final_highlight_color_location = 1.0f;
static float const k_default_calendar_non_key_selected_grid_color_angle = 90.0f;

static float const k_default_calendar_marker_oval_scale_factor = 0.9f;

static NSUInteger const k_default_calender_show_week_per_month = 6;

#endif
