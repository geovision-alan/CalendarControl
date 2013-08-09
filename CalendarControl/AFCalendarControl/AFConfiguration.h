//
//  AFConfiguration.h
//
//  Created by alantseng on 7/9/13.
//  Copyright (c) 2013. All rights reserved.
//

#ifndef AFConfiguration_h
#define AFConfiguration_h

#define USE_AFDRAWSTRING 0

static float const k_default_calendar_key_title_background_color_begin[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_key_title_background_color_middle[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_key_title_background_color_end[4] = {0.7f, 0.7f, 0.7f, 1.0f};
static float const k_default_calendar_non_key_title_background_color_begin[4] = {0.8f, 0.8f, 0.8f, 1.0f};
static float const k_default_calendar_non_key_title_background_color_end[4] = {0.8f, 0.8f, 0.8f, 1.0f};
static float const k_default_calendar_title_background_color_angle = -90.0f;
static float const k_default_calendar_title_text_color[4] = {0.0f, 0.0f, 0.0f, 1.0f};
static float const k_default_calendar_title_shadow_color[4] = {0.5f, 0.5f, 0.5f, 1.0f};
static float const k_default_calendar_title_shadow_offset[2] = {0.0f, -1.0f};
static float const k_default_calendar_title_shadow_blur_radius = 3.0f;

static float const k_default_calendar_background_path_color[4] = {0.0f, 0.0f, 0.0f, 0.7f};
static float const k_default_calendar_background_path_width = 5.0f;

static NSString* const k_default_calendar_month_year_font_name = @"Helvetica Bold";
static float const k_default_calendar_month_year_font_size = 12.0f;
static NSString* const k_default_calendar_week_day_font_name = @"Helvetica Bold";
static float const k_default_calendar_week_day_font_size = 10.0f;
static NSString* const k_default_calendar_month_day_font_name = @"Helvetica Bold";
static float const k_default_calendar_month_day_font_size = 14.0f;

static float const k_default_calendar_grid_path_shadow_color[4] = {1.0f, 1.0f, 1.0f, 0.8f};
static float const k_default_calendar_key_grid_path_color[4] = {0.7f, 0.7f, 0.7f, 1.0f};
static float const k_default_calendar_non_key_grid_path_color[4] = {0.7f, 0.7f, 0.7f, 1.0f};

static float const k_default_calendar_select_grid_text_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_today_grid_text_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_enable_grid_text_color[4] = {0.0f, 0.0f, 0.0f, 1.0f};
static float const k_default_calendar_disable_grid_text_color[4] = {0.5f, 0.5f, 0.5f, 0.5f};
static float const k_default_calendar_select_grid_shadow_color[4] = {0.2f, 0.2f, 0.2f, 1.0f};
static float const k_default_calendar_today_grid_shadow_color[4] = {0.2f, 0.2f, 0.2f, 1.0f};
static float const k_default_calendar_enable_grid_shadow_color[4] = {0.5f, 0.5f, 0.5f, 1.0f};
static float const k_default_calendar_disable_grid_shadow_color[4] = {0.5f, 0.5f, 0.5f, 1.0f};
static float const k_default_calendar_grid_shadow_offset[2] = {0.0f, -1.0f};
static float const k_default_calendar_grid_shadow_blur_radius = 2.0f;
static float const k_default_calendar_today_grid_interior_shadow_color[4] = {1.0f, 1.0f, 0.0f, 0.5f};
static float const k_default_calendar_today_grid_interior_shadow_offset[4] = {20.0f, 20.0f, 20.0f, 15.0f};
static float const k_default_calendar_today_grid_interior_shadow_radius = 2.0f;

static float const k_default_calendar_key_grid_color[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float const k_default_calendar_key_today_grid_color[4] = {0.9f, 0.8f, 0.0f, 1.0f};
static float const k_default_calendar_key_today_and_selected_grid_color[4] = {73.0f/255.0f, 179.0f/255.0f, 70.0f/255.0f, 1.0f};
static float const k_default_calendar_non_key_grid_color[4] = {0.5f, 0.5f, 0.5f, 1.0f};
static float const k_default_calendar_non_key_today_grid_color[4] = {0.5f, 0.4f, 0.0f, 1.0f};
static float const k_default_calendar_non_key_today_and_selected_grid_color[4] = {13.0f/255.0f, 109.0f/255.0f, 0.0f/255.0f, 1.0f};

static float const k_default_calendar_key_selected_grid_base_color[4] = {240.0f/255.0f, 85.0f/255.0f, 65.0f/255.0f, 1.0f};
static float const k_default_calendar_key_selected_grid_base_highlight_color[4] = {240.0f/255.0f, 85.0f/255.0f, 65.0f/255.0f, 1.0f};
static float const k_default_calendar_key_selected_grid_final_highlight_color[4] = {240.0f/255.0f, 85.0f/255.0f, 65.0f/255.0f, 1.0f};
static float const k_default_calendar_key_selected_grid_base_color_location = 0.0f;
static float const k_default_calendar_key_selected_grid_base_highlight_color_location = 0.5f;
static float const k_default_calendar_key_selected_grid_final_highlight_color_location = 1.0f;
static float const k_default_calendar_key_selected_grid_color_angle = 90.0f;

static float const k_default_calendar_non_key_selected_grid_base_color[4] = {140.0f/255.0f, 5.0f/255.0f, 5.0f/255.0f, 1.0f};
static float const k_default_calendar_non_key_selected_grid_base_highlight_color[4] = {140.0f/255.0f, 5.0f/255.0f, 5.0f/255.0f, 1.0f};
static float const k_default_calendar_non_key_selected_grid_final_highlight_color[4] = {140.0f/255.0f, 5.0f/255.0f, 5.0f/255.0f, 1.0f};
static float const k_default_calendar_non_key_selected_grid_base_color_location = 0.0f;
static float const k_default_calendar_non_key_selected_grid_base_highlight_color_location = 0.5f;
static float const k_default_calendar_non_key_selected_grid_final_highlight_color_location = 1.0f;
static float const k_default_calendar_non_key_selected_grid_color_angle = 90.0f;

static NSUInteger const k_default_calender_show_week_per_month = 6;

#endif
